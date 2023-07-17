import sys
import os


dir = os.path.dirname( __file__ )
src_pos = dir.index('src')
src_path = dir[:src_pos] + os.path.join('src','test','TestLib')
sys.path.append( src_path )

dir = os.path.dirname( __file__ )
src_pos = dir.index('src')
src_path = dir[:src_pos] + os.path.join('src','common','Context')
sys.path.append( src_path )

from TestLib import TestLib   

from ContextList import ContextList

test = TestLib()
def test_ContextLibs_HttpCodeVerification_for_FPX():
    test.tc( 'test_ContextLibs_toString' )
    contexts = ContextList()
    ctx = contexts.get_context( "fpx" )
    
    exp = 200
    cur = ctx.get_Success_Get()
    test.assertEquals( exp, cur, 'get_Success_Get() - The success code are note equals. exp(' + str( exp ) + ') != cur(' +str( cur ) + ')' )
    
    exp = 200
    cur = ctx.get_Success_Get_NoContent()
    test.assertEquals( exp, cur, 'get_Success_Get_NoContent() - The success code are note equals. exp(' + str( exp ) + ') != cur(' +str( cur ) + ')' )

    exp = 200
    cur = ctx.get_Success_Post()
    test.assertEquals( exp, cur, 'get_Success_Post() - The success code are note equals. exp(' + str( exp ) + ') != cur(' +str( cur ) + ')' )

    exp = 200
    cur = ctx.get_Success_Post_NoContent()
    test.assertEquals( exp, cur, 'get_Success_Post_NoContent() - The success code are note equals. exp(' + str( exp ) + ') != cur(' +str( cur ) + ')' )

    exp = 200
    cur = ctx.get_Success_Put()
    test.assertEquals( exp, cur, 'get_Success_Put() - The success code are note equals. exp(' + str( exp ) + ') != cur(' +str( cur ) + ')' )

    exp = 200
    cur = ctx.get_Success_Put_NoContent()
    test.assertEquals( exp, cur, 'get_Success_Put_NoContent() - The success code are note equals. exp(' + str( exp ) + ') != cur(' +str( cur ) + ')' )

    exp = 200
    cur = ctx.get_Success_Delete()
    test.assertEquals( exp, cur, 'get_Success_Delete() - The success code are note equals. exp(' + str( exp ) + ') != cur(' +str( cur ) + ')' )

    exp = 200
    cur = ctx.get_Success_Delete_NoContent()
    test.assertEquals( exp, cur, 'get_Success_Delete_NoContent() - The success code are note equals. exp(' + str( exp ) + ') != cur(' +str( cur ) + ')' )

    exp = 200
    cur = ctx.get_Success_Patch()
    test.assertEquals( exp, cur, 'get_Success_Patch() - The success code are note equals. exp(' + str( exp ) + ') != cur(' +str( cur ) + ')' )

    exp = 200
    cur = ctx.get_Success_Patch_NoContent()
    test.assertEquals( exp, cur, 'get_Success_Patch_NoContent() - The success code are note equals. exp(' + str( exp ) + ') != cur(' +str( cur ) + ')' )

    exp = 400
    cur = ctx.get_No_User()
    test.assertEquals( exp, cur, 'get_No_User() - The success code are note equals. exp(' + str( exp ) + ') != cur(' +str( cur ) + ')' )

    exp = 401
    cur = ctx.get_Unauthorized_Access()
    test.assertEquals( exp, cur, 'get_Unauthorized_Access() - The success code are note equals. exp(' + str( exp ) + ') != cur(' +str( cur ) + ')' )

    exp = 403
    cur = ctx.get_Forbidden()
    test.assertEquals( exp, cur, 'get_Forbidden() - The success code are note equals. exp(' + str( exp ) + ') != cur(' +str( cur ) + ')' )

    exp = 500
    cur = ctx.get_Server_Error()
    test.assertEquals( exp, cur, 'get_Server_Error() - The success code are note equals. exp(' + str( exp ) + ') != cur(' +str( cur ) + ')' )
    
    
def test_ContextLibs_HttpCodeVerification_for_dover():
    test.tc( 'test_ContextLibs_HttpCodeVerification_for_dover' )
    contexts = ContextList()
    ctx = contexts.get_context( "dover" )
    
    exp = 200
    cur = ctx.get_Success_Get()
    test.assertEquals( exp, cur, 'get_Success_Get() - The success code are note equals. exp(' + str( exp ) + ') != cur(' +str( cur ) + ')' )
    
    exp = 200
    cur = ctx.get_Success_Get_NoContent()
    test.assertEquals( exp, cur, 'get_Success_Get_NoContent() - The success code are note equals. exp(' + str( exp ) + ') != cur(' +str( cur ) + ')' )

    exp = 200
    cur = ctx.get_Success_Post()
    test.assertEquals( exp, cur, 'get_Success_Post() - The success code are note equals. exp(' + str( exp ) + ') != cur(' +str( cur ) + ')' )

    exp = 200
    cur = ctx.get_Success_Post_NoContent()
    test.assertEquals( exp, cur, 'get_Success_Post_NoContent() - The success code are note equals. exp(' + str( exp ) + ') != cur(' +str( cur ) + ')' )

    exp = 200
    cur = ctx.get_Success_Put()
    test.assertEquals( exp, cur, 'get_Success_Put() - The success code are note equals. exp(' + str( exp ) + ') != cur(' +str( cur ) + ')' )

    exp = 200
    cur = ctx.get_Success_Put_NoContent()
    test.assertEquals( exp, cur, 'get_Success_Put_NoContent() - The success code are note equals. exp(' + str( exp ) + ') != cur(' +str( cur ) + ')' )

    exp = 200
    cur = ctx.get_Success_Delete()
    test.assertEquals( exp, cur, 'get_Success_Delete() - The success code are note equals. exp(' + str( exp ) + ') != cur(' +str( cur ) + ')' )

    exp = 200
    cur = ctx.get_Success_Delete_NoContent()
    test.assertEquals( exp, cur, 'get_Success_Delete_NoContent() - The success code are note equals. exp(' + str( exp ) + ') != cur(' +str( cur ) + ')' )

    exp = 200
    cur = ctx.get_Success_Patch()
    test.assertEquals( exp, cur, 'get_Success_Patch() - The success code are note equals. exp(' + str( exp ) + ') != cur(' +str( cur ) + ')' )

    exp = 200
    cur = ctx.get_Success_Patch_NoContent()
    test.assertEquals( exp, cur, 'get_Success_Patch_NoContent() - The success code are note equals. exp(' + str( exp ) + ') != cur(' +str( cur ) + ')' )

    exp = 400
    cur = ctx.get_No_User()
    test.assertEquals( exp, cur, 'get_No_User() - The success code are note equals. exp(' + str( exp ) + ') != cur(' +str( cur ) + ')' )

    exp = 401
    cur = ctx.get_Unauthorized_Access()
    test.assertEquals( exp, cur, 'get_Unauthorized_Access() - The success code are note equals. exp(' + str( exp ) + ') != cur(' +str( cur ) + ')' )

    exp = 403
    cur = ctx.get_Forbidden()
    test.assertEquals( exp, cur, 'get_Forbidden() - The success code are note equals. exp(' + str( exp ) + ') != cur(' +str( cur ) + ')' )

    exp = 500
    cur = ctx.get_Server_Error()
    test.assertEquals( exp, cur, 'get_Server_Error() - The success code are note equals. exp(' + str( exp ) + ') != cur(' +str( cur ) + ')' )


def test_ContextLibs_HttpCodeVerification_for_cpq():
    test.tc( 'test_ContextLibs_HttpCodeVerification_for_cpq' )
    contexts = ContextList()
    ctx = contexts.get_context( "cpq" )
    
    exp = 200
    cur = ctx.get_Success_Get()
    test.assertEquals( exp, cur, 'get_Success_Get() - The success code are note equals. exp(' + str( exp ) + ') != cur(' +str( cur ) + ')' )
    
    exp = 204
    cur = ctx.get_Success_Get_NoContent()
    test.assertEquals( exp, cur, 'get_Success_Get_NoContent() - The success code are note equals. exp(' + str( exp ) + ') != cur(' +str( cur ) + ')' )

    exp = 201
    cur = ctx.get_Success_Post()
    test.assertEquals( exp, cur, 'get_Success_Post() - The success code are note equals. exp(' + str( exp ) + ') != cur(' +str( cur ) + ')' )

    exp = 204
    cur = ctx.get_Success_Post_NoContent()
    test.assertEquals( exp, cur, 'get_Success_Post_NoContent() - The success code are note equals. exp(' + str( exp ) + ') != cur(' +str( cur ) + ')' )

    exp = 200
    cur = ctx.get_Success_Put()
    test.assertEquals( exp, cur, 'get_Success_Put() - The success code are note equals. exp(' + str( exp ) + ') != cur(' +str( cur ) + ')' )

    exp = 204
    cur = ctx.get_Success_Put_NoContent()
    test.assertEquals( exp, cur, 'get_Success_Put_NoContent() - The success code are note equals. exp(' + str( exp ) + ') != cur(' +str( cur ) + ')' )

    exp = 200
    cur = ctx.get_Success_Delete()
    test.assertEquals( exp, cur, 'get_Success_Delete() - The success code are note equals. exp(' + str( exp ) + ') != cur(' +str( cur ) + ')' )

    exp = 204
    cur = ctx.get_Success_Delete_NoContent()
    test.assertEquals( exp, cur, 'get_Success_Delete_NoContent() - The success code are note equals. exp(' + str( exp ) + ') != cur(' +str( cur ) + ')' )

    exp = 200
    cur = ctx.get_Success_Patch()
    test.assertEquals( exp, cur, 'get_Success_Patch() - The success code are note equals. exp(' + str( exp ) + ') != cur(' +str( cur ) + ')' )

    exp = 204
    cur = ctx.get_Success_Patch_NoContent()
    test.assertEquals( exp, cur, 'get_Success_Patch_NoContent() - The success code are note equals. exp(' + str( exp ) + ') != cur(' +str( cur ) + ')' )

    exp = 400
    cur = ctx.get_No_User()
    test.assertEquals( exp, cur, 'get_No_User() - The success code are note equals. exp(' + str( exp ) + ') != cur(' +str( cur ) + ')' )

    exp = 401
    cur = ctx.get_Unauthorized_Access()
    test.assertEquals( exp, cur, 'get_Unauthorized_Access() - The success code are note equals. exp(' + str( exp ) + ') != cur(' +str( cur ) + ')' )

    exp = 403
    cur = ctx.get_Forbidden()
    test.assertEquals( exp, cur, 'get_Forbidden() - The success code are note equals. exp(' + str( exp ) + ') != cur(' +str( cur ) + ')' )

    exp = 500
    cur = ctx.get_Server_Error()
    test.assertEquals( exp, cur, 'get_Server_Error() - The success code are note equals. exp(' + str( exp ) + ') != cur(' +str( cur ) + ')' )


test_ContextLibs_HttpCodeVerification_for_FPX()
test_ContextLibs_HttpCodeVerification_for_dover()
test_ContextLibs_HttpCodeVerification_for_cpq()