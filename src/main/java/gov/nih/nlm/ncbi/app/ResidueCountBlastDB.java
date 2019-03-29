/* 
 * ===========================================================================
 *
 *                            PUBLIC DOMAIN NOTICE
 *               National Center for Biotechnology Information
 *
 *  This software/database is a "United States Government Work" under the
 *  terms of the United States Copyright Act.  It was written as part of
 *  the author's official duties as a United States Government employee and
 *  thus cannot be copyrighted.  This software/database is freely available
 *  to the public for use. The National Library of Medicine and the U.S.
 *  Government have not placed any restriction on its use or reproduction.
 *
 *  Although all reasonable efforts have been taken to ensure the accuracy
 *  and reliability of the software and data, the NLM and the U.S.
 *  Government do not and cannot warrant the performance or results that
 *  may be obtained by using this software or data. The NLM and the U.S.
 *  Government disclaim all warranties, express or implied, including
 *  warranties of performance, merchantability or fitness for any particular
 *  purpose.
 *
 *  Please cite the author in any work or product based on this material.
 *
 * ===========================================================================
 */

package gov.nih.nlm.ncbi.app;

import org.apache.spark.api.java.JavaRDD;

import org.apache.spark.SparkConf;
import org.apache.spark.api.java.JavaSparkContext;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

import java.nio.file.Paths;
import java.nio.file.Path;
import java.nio.file.Files;

import java.util.List;
import java.util.ArrayList;
import java.util.Collection;

import com.google.common.base.Stopwatch;
import com.google.api.services.storage.Storage;
import com.google.api.client.googleapis.auth.oauth2.GoogleCredential;
import com.google.api.client.googleapis.javanet.GoogleNetHttpTransport;
import com.google.api.client.http.HttpTransport;
import com.google.api.client.json.JsonFactory;
import com.google.api.client.json.jackson2.JacksonFactory;
import com.google.api.services.storage.StorageScopes;
import java.security.GeneralSecurityException;

import org.apache.commons.cli.ParseException;

/** Program to count residues a binary file downloaded from a GS bucket
 *
 * @author Greg Boratyn
 */
public class ResidueCountBlastDB {

  //private static final Log LOG = LogFactory.getLog(ResidueCount.class);
    public static void main(String[] args) throws ParseException,
                                                  GeneralSecurityException,
                                                  IOException {

    SparkConf conf = new SparkConf();
    conf.setAppName("residue-count-blastdb");
    JavaSparkContext sc = new JavaSparkContext(conf);

    final String bucket = "nt_50mb_chunks";
    final String dest = "/tmp/";
    ArrayList<String> dbchunks = new ArrayList<String>();
    for (int i=0;i < 10;i++) {
        dbchunks.add(String.format("nt_50M.0%d.nsq", i));
    }
    for (int i=10;i < 887;i++) {
        dbchunks.add(String.format("nt_50M.%d.nsq", i));
    }

    JavaRDD<String> dbnames = sc.parallelize(dbchunks, 64);

    // download database files
    JavaRDD<String> db = dbnames.map(item -> {
                           Storage storage =
                               buildStorageService("residue-count-blastdb");

                           download_to_file(storage, bucket, item,
                                            dest + item);
                           return dest + item;
                                     } ).cache();
    
    // count bytes
    for (int i=0;i < 5;i++) {
        Stopwatch timer = new Stopwatch().start();
        Integer result = db.map(f -> countBytes(f)).reduce((a, b) -> a + b);
        timer.stop();
        System.out.println(String.format("TIME: Byte 0x01 found %d time in %s",
                                         result, timer));
    }

    // delete files from worker nodes
    db.map(f -> deleteFile(f)).collect();

    sc.stop();
  }


    /**
     * Create Storage-instance, needed for access to GS buckets
     *
     * @param appName  name of the application to be given to the
     * storage-instance
     * @return Storage-instance
     */
    private static Storage buildStorageService( final String appName ) 
        throws GeneralSecurityException, IOException
    {
        HttpTransport transport = GoogleNetHttpTransport.newTrustedTransport();
        JsonFactory jsonFactory = new JacksonFactory();
        GoogleCredential credential = GoogleCredential.getApplicationDefault( transport, jsonFactory );

        if ( credential.createScopedRequired() ) {
            Collection<String> scopes = StorageScopes.all();
            credential = credential.createScoped( scopes );
        }

        return new Storage.Builder( transport, jsonFactory, credential )
             .setApplicationName( appName ).build();
    }


    /**
     * Download a file from a bucket to the local filesystem
     *
     * @param  storage       storage object
     * @param  bucket        url of the bucket
     * @param  key           name of the 'file' in the bucket to be downloaded
     * @param  dst_filename  absolute path of destination-file to be created
     *
     * @return  success of operation
     */
    private static boolean download_to_file( final Storage storage,
                                             final String bucket,
                                             final String key,
                                             final String dst_filename )
    {
        boolean res = true;
        if ( res )
        {
            try
            {
                Storage.Objects.Get obj = storage.objects().get( bucket, key );
                if (obj == null) {
                    System.err.println("Get object could not be created");
                }
                res = ( obj != null );
                if ( res )
                {

                    File f = new File( dst_filename );
                    FileOutputStream f_out = new FileOutputStream( f );

                    try
                    {
                        try {
                            obj.executeMediaAndDownloadTo( f_out );
                        }
                        catch( Exception e ) {
                            e.printStackTrace();
                            res = false;
                        }
                    }
                    catch( Exception e )
                    {
                        e.printStackTrace();
                        res = false;
                    }
                    finally
                    {
                        f_out.flush();
                        f_out.close();
                    }
                    if ( !res )
                    {
                        try
                        {
                            if ( f.exists() )
                                f.delete();
                        }
                        catch( Exception e )
                        {
                            e.printStackTrace();
                        }
                    }
                }
            }
            catch( Exception e )
            {
                e.printStackTrace();
                res = false;
            }
        }
        return res;
    }


    /** Count bytes equal to 1 in a binary file
     *
     *  @param filename File name
     *  @return Number of bytes equal to 1
     */
    private static Integer countBytes(final String filename) throws IOException
    {
        int count = 0;
        Path path = Paths.get(filename);
        byte[] fileContents = Files.readAllBytes(path);
        
        for (byte b: fileContents) {
            //count bytes equal to 1
            if (b == 1) {
                count++;
            }
        }
        System.out.println(String.format("Count in %s: %d", filename, count));

        return count;
    }


    /** Delete a file
     *  @param filename File name
     *  @return zero
     */
    private static int deleteFile(final String filename) throws IOException
    {
        System.out.println(String.format("Deleting %s", filename));
        File f = new File(filename);
        f.delete();

        return 0;
    }
}

