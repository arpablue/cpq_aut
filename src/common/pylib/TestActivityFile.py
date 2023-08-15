from robot.libraries.BuiltIn import BuiltIn
from robot.api.deco import library
from robot.api.deco import keyword
from robot.api import logger
import os
import sys
import datetime
dir = os.path.dirname( __file__ )
src_pos = dir.index('src')
src_path = dir[:src_pos] + os.path.join('src','common','pylib')
sys.path.append( src_path )


from LogFile import LogFile
###
# It register the data of a test case.
###
@library
class TestActivityFile( LogFile ):
    ###
    # Default constructor.
    ###
    def __init__( self ):
        self.open()
    ###
    # It return the current instant time.
    # -return(String): It is the instant time.
    ###
    def get_time_execution(self):
        date = datetime.datetime.now()
        return date.strftime("%Y%m%d")
    ###
    # It return the foldder of the project,
    # -return(String): It is the folder of the project.
    ###
    def get_prj_directory( self ):
        dir = os.path.dirname( __file__ )
        src_pos = dir.index('src')
        return dir[:src_pos] 
    ###
    # It return the path of the current test activity file
    # -return(String): It is the path of the current activity file.
    ###
    def get_test_result_file( self ):
        # prepare the current nime
        rand = 'tr_' + self.get_time_execution()
        sep = os.path.sep
        # get the project folder
        dir = self.get_prj_directory()
        try: 
            # Get the name of the *.robot file
            suite_source = BuiltIn().get_variable_value("${SUITE_SOURCE}")
            suite_source = suite_source.replace( dir , "" ) # deleting the refrence to the folder        
            suite_source = suite_source.replace( "test_cases" , "" ) # deleting the refrence to the folder
            
            # Get the name of the test case execution
            test_name = BuiltIn().get_variable_value("${TEST_NAME}")
            
            # Create the name of the activity log file
            test_name = test_name.strip().replace(" ","_") + ".log"
            
            # prepare the folder
            # Generate the folder related to the *.robot file
            folder = suite_source.replace(".robot","")
            
            # To concate the project folder with the folder of the *.robt file
            dir = dir + sep + "test_result" + sep+ rand +sep + folder
            dir = dir.replace( sep +sep, sep)
            
            self.mkdir( dir )
            dir = dir + sep + test_name
            dir = dir.replace( sep +sep, sep)
            return dir
        except NameError:
            print( 'It is necesary run under ROBOT FRAMEWORK to create log files.' )
        return []
        
    ###
    # It write a message in the current test activity file.
    # -param msg(String): It is the message to write in the file.
    ###
    @keyword
    def writeln(self, msg):
        file = self.get_test_result_file()
        if file == None:
            logger.console("ERROR: It is necessary in a ROBOT FRAMEWORK context to createthe activity files.")
            return
        self.set_file( file )
        self.open()
        super().writeln( msg )
        self.close()
        