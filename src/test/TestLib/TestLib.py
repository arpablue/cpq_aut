import colorama
from colorama import Fore



class TestLib:
    
    def passed( text ):
        print( Fore.GREEN + "PASS - " +text + Fore.WHITE )
        
    def failed( text ):
        print( Fore.RED + "FAIL - " +text + Fore.WHITE )

    def assertEqual( exp, cur, message ):
        print( "   Expected: " + str( exp ) )
        print( "    Current: " + str( cur ) )
        if exp == cur :
            self.passed( "The elements are equals." )
        else:
            self.failed( "The elements are not equeals, when should be equals." )

    def assertNotEqual( exp, cur, message ):
        print( "   Expected: " + str( exp ) )
        print( "    Current: " + str( cur ) )
        if not exp == cur :
            self.passed( "The elements are not equals." )
        else:
            self.failed( "The elements are equeals, when should not be equals." )
    def tc( self, tcName ):
        print( Fore.BLUE + "\n-------- TC: " + str( tcName ) + Fore.WHITE )