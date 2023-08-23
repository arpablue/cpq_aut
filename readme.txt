                                CPQ AUT 
						=========================
                            Automation Project


The current document contains information and description about the execution, structure and 
test results of the automation.

The project use two type of context, one is the execution context, related to the server where 
the requests will be did and the second is the context data it is the source of the data, for 
example the data from the API services this is the API context and another is the data from the 
file, it is the FILE context.

Currently the project has been developed and executed in Windows OS.

1) SETTINGS
================
It is possible to specify the execution context of the project using the value of some file. The
project has the following settings file:


- config.yml :  It contains the initial settings for the execution of the project, it is under 
				development.

     + context: It is the context of the execution , currently is used teh cpq, to see the 
				context execution are specified in the ../resources/config/context.json file.

     + file_output: It is a binary value, the value 1 allows to create the activity logs of the 
					test cases in the test results folder.

     + console_output: It allows show the activity of the test cases in the console, the value 1 
	 allows display the messages and the 0 doesn't display messages.

     + url: It is the URL used to make the http requests.

     + content_type: It is the type of the content type used in the http requests.

     + SessionID: It is the ID of the session for the requests, currently  it is deprecated.

     + token: It is the token used in the http requests.


2) EXECUTION
================
In the project the test cases are in the <prj_folder>/test_cases folder, in this folder there are 
two folders:

     - test_plan: In this folder there are the test cases to be executed with a specific 
					objective ( functionality, verification, regression, etc); these test 
					plans contain the execution of different areas.

    - us: This folder contains the execution of the test cases for a specific user story ( acceptance,
		functionality, negative, etc). This folder contains another folder with the name of the user 
		story of the test plans.

    +cpq_aut
        +---test_cases
        |   +---test_plan
        |   +---us
        |       +---CPQ-140_Roles
        |       +---CPQ-140_UserManagement
        |       +---CPQ_122_Quotes
        |       +---CPQ_123_QuoteLines
        |       +---CPQ_124_Opportunities


In each folder you can see the test plans for the execution In the title has the objective of 
the test plans, the following test plans are some examples:

    - TS_Acceptance: The test cases in this test plan are executed to verify the acceptance 
					criteria specified in the respective user story.

   - TS_Functionality: the test cases in this test plan are executest to verify additional 
					functionality that are not specified in the acceptance criteria, but are 
					necessary to verify the correct functionality or for future improvements.

    - TS_Negative: The test cases in this test plan are executed to verify the correct behavior 
				of the improvement in scenarios created to fail, invalid values and unexpected 
				behavior.

To execute the test case it is possible use a terminal, go to the test plans to be execute and 
execute robot framework command line:

python -m robot TS_Acceptance.robot

Additionally to this in each folder, a batch file exists to execute each test plan in the folder,
these files can be used as an example  to execute another test plan.

    +cpq_aut
        +---test_cases
        |   +---us
        |       +---CPQ-140_Roles
        |   |          - TS_Acceptance.robot
        |   |          - accept.bat
        |       +---CPQ-124_Opportunities
        |   |          - accept.bat
        |   |          - functional.bat
        |   |          - negative.bat



After the execution, ROBOT FRAMEWORK will create the files related to the test results. 
Additionally to this the automation framework creates log files, related to the data and 
activities related to the execution of test cases, These are created in the 
<prj_folder>/test_result folder of the project, This are created in the folder with the current 
date, ex: <prj_folder>/test_result/tr_<year><month><date>.

    +cpq_aut
        +---test_cases
        |   +---us
        |       +---CPQ-140_Roles
        |   |          - TS_Acceptance.robot
        |   |          - accept.bat
        |       +---CPQ-124_Opportunities
        |   |          - TS_Acceptance.robot
        |   |          - TS_Functional.robot
        |   |          - TS.Negative.robot
        |   |          - accept.bat
        |   |          - functional.bat
        |   |          - negative.bat


In the <prj_folder>\test_result folder, in this folder the 2 batch files:

    - accept.bat : It executes all test cases related to the acceptance test from the user story.

    - test.bat: It executes all test cases related to the CPQ-124 user story.



3) ARCHITECTURE 
===============
The architecture of the folder is divided into the following folders.

    +cpq_aut
        +---docs
        +---resources
        +---src
        +---test_cases
        +---test_result

- docs: This folder contains the documentation used to develop the project.
- resources: It contains the data used for the execution of the automation.
	The resources folder contains 3 folder

    + config: This folders contains the files for the execution of the automation under a context.
			The followings files exists in this folder:

        * context.json : It contains the data about the context used in the automation, from the 
						url ( at the moment  is not used ) and the status code used for validation
						of the requests.

    + data : (in development) For the execution of the automation, some data cannot be obtained 
			from the API, but is necessary for the execution, then this data exists in this 
			files and used in the execution of the test cases, the name of the file describe the 
			type of the data that file contain, the first line of the file contain the name of the
			columns and each column is separate by double white spaces.

    + records: During the execution of the automation, some test cases have to create some objects 
			in the system, each object created in the system can be registered in one this file, 
			this allows get some of this object be used for future test cases, in this files only 
			the IDs of each object are saved, is recommended create a new file for future new 
			objects.

- src: It contains the libraries, classes, modules and main code of the execution of the project. Each sub-folder is the implementation under a specific context.

    + api: It is the implementation to interact with the PQQ API services.
    + common: It is the implementation of resources, libraries and objects to be used in other 
			contexts.
    + file: It is the implementation to interact with the data in the data and records folder of 
			the project.
    + obj: It is the implementation of the base objects to be used in all contexts.
	
- test cases: It contains the implementation of the test plans, test suites and test cases of the
			automation.
			
- test result: In this folder the execution of the automation, the log files, are registered.


4) DEVELOPMENT
================
This section contains the description of the development philosophy.

A) 3rd level development
----------------------------
The development structure of 3rd level, this means that all main development files are created at
the 3rd level folder of the project.


It is the 3rd level for the SRC folder.


    +cpq_aut
        +---src
        |   +---api
        |   |   +---OpportunityAPI
        |   |          - OpportunityAPI_ext.py
        |   |          - OpportunityAPI_steps.resource
        |   |          - OpportunityAPI.resource
        |   |   +---RoleAPI
        |   |          - RoleAPI_ext.py
        |   |          - RoleAPI_steps_resource
        |   |          - RoleAPI.resource


It is the 3rd level for the test cases folder.

    +cpq_aut
        +---test_cases
        |   +---us
        |       +---CPQ-140_Roles
        |   |          - TS_Acceptance.robot
        |   |          - accept.bat
        |       +---CPQ-124_Opportunities
        |   |          - TS_Acceptance.robot
        |   |          - TS_Functional.robot
        |   |          - TS.Negative.robot
        |   |          - accept.bat
        |   |          - functional.bat
        |   |          - negative.bat

This allows executing the test cases from other levels of the application or call libraries from 
another part of the code.


B) Object Data
--------------------
The object data  has the objective of managing the fields and values of the entities in the 
system, if necessary has implementation of specific methods for the specific Objects, this object 
has as goal, manage the data between contexts and interaction between entities. 

Each entity has its own Obj object, implemented in the <prj_folder>/src/obj/  folder, where each 
object has a folder and inside of each folder contains the implementation of the data object, ex:

	- ../src/obj/ OpportunityObj / OpportunityObj.py
	- ../src/ QuoteObj / QuoteObj.py
	- .../src/ QuoteLine / QuoteLineObj.py


C) API
-----------
The API is used to interact with REST API service, the implementation is in the ../src/API folder,
each entity has a implementation folder, ex:

	-  ../src/API / OpportunityAPI 
	-  ../src/API / QuoteAPI
	-  ../src/API / QuoteLine


In each folder contains the files to allow the manage and expand the manipulation of the objects,
but the main the main files that should be call from other part of the project is the same name 
of the folder with .resource and _steps.resource extensions, ex: 

	-  ../src/API / OpportunityAPI / OpportunityAPI.resource
	-  ../src/API / OpportunityAPI / OpportunityAPI_steps.resource

	-  ../src/API / QuoteAPI / QuoteAPI.resource
	-  ../src/API / QuoteAPI / QuoteAPI_steps.resource

	-  ../src/API / QuoteLine / QuoteLine.resource
	-  ../src/API / QuoteLine / QuoteLineAPI_steps.resource


The first file, for example the OpportunityAPI.resource, contains basic methods to manage the data
that are the implementation of the http requests: create( POST ), getInfo( GET ), update(PUT), 
delete(DELETE) and other methods thats simplify the actions over the Entity as “exists by ID” that 
use the GET request and additionals validations to return a True or False.

The second file, for example the OpportunityAPI_steps.resource file, contains the basic test case
steps applied to the entity and can be used in different parts of the automation, these steps 
have more complexity and verification process.


D) File Objects
-----------------------
These objects work with the files in the ../src/resources/data folder, the objective is to use 
data that it is not possible to obtain from the API services, but it is specific in these files.

The data of the entities that interact with these files are implemented in the ../src/file folder
where each entity have a folder specified by the name of the entity follow by the File text, where
the main files have the same name of the folder with the .resource extension:

ex:

    +cpq_aut
        +---src
        |   +---file
        |   |   +---PartnerFile
        |   |   |   +--- PartnerFile.resource
        |   |   +---PermissionFile
        |   |   |   +--- PermissionFile.resource
        |   |   +---RoleFile
        |   |   |   +--- RoleFile.resource
        |   |   +---UserFile
        |   |   |   +--- UserFile.resource


E) Common
---------------
In this folder are implemented the objects and methods that are used in the execution of the 
automation.

    +cpq_aut
        +---src
        |   +---common
        |   |   +---Context
        |   |   +---libs
        |   |   +---pylib
    
- context : In this folder are implemented the objects to manage the contexts. This data is
			specified in the ./resources/config/context.json file, in this folder the file that 
			it is possible find are:

        + Context.py : It is the object to manage the current object.
        + ContextList.py : It manages the list of context specified.

    - libs: In this folder are implemented the global libraries used in the execution of the 
			automation. In this folder it is possible find the following files:

        + GlobalAPI.resource :  It contains the main method for the execution of the test cases, 
			validations methods and log method to write in the activities files.

        + Validations.resource : It contains the method for the validation, it generaid a fail 
								status and registers the error in the activity files.

    - libs : In this folder the objects for the general or used for python code.

        + RecordFile.py : It creates activity files to register the actions by the automation.

        + FileReader.py : It helps to read the content of a file.

    - test: It is used to create unit tests for the methods development for the automation. 


5) Test cases
==============
The test cases are created in the ../test_cases folder, in this folder we have two folders.

    - test_plans : It contains the test plan created for the project.
    - us : It contains the implementation of the test cases of the user store, for the details 
			go in the execution section.


6) Test results
==============
Robot framework creates a test result report in the folder where the command line has been 
executed, but the execution of the automation creates an activities file with information of the 
action and data used during the execution, these activity files are created in the ../test_result
folder, for more detail the execution section of this file.



