import colorama
from colorama import Fore



class TestLib:
    
    def passed( self, text ):
        print( Fore.GREEN + "PASS - " +text + Fore.WHITE )
        
    def failed( self, text ):
        print( Fore.RED + "FAIL - " +text + Fore.WHITE )

    def assertEquals( self, exp, cur, message ):
        if not exp == cur :
            print( "   Expected: " + str( exp ) )
            print( "    Current: " + str( cur ) )
            self.failed( "The elements are not equals, when should be equals." )

    def assertNotEqual( self, exp, cur, message ):
        if exp == cur :
            print( "   Expected: " + str( exp ) )
            print( "    Current: " + str( cur ) )
            self.failed( "The elements are equals, when should not be equals." )   
    def tc( self, tcName ):
        print( Fore.BLUE + "\n-------- TC: " + str( tcName ) + Fore.WHITE )