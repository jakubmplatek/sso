@isTest
private class GoogleAuthHandlerTest {
    private static final String email = 'testuser@example.org';
    private static final String username = email + '.' + DateTime.now().getTime();
    @testSetup
    private static void initTestData() {
        system.debug(email);
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr = new User(
            Email=email,
            Username=username,
            ProfileId=profile.Id,
            LastName='testLast',
            Alias='tuser',
            EmailEncodingKey='UTF-8',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Los_Angeles'
        );
        insert usr;
    }
    @isTest
    private static void testLoginFailure() {
        GoogleAuthHandler handler = new GoogleAuthHandler();
        Auth.UserData authUserData = new Auth.UserData('testId', 'testFirst', 'testLast',
            'testFirst testLast', email, null, username, 'en_US', 'google',
            null, new Map<String, String>{'language' => 'en_US'});
        User usr;
        Test.startTest();
        usr = handler.createUser(null, authUserData);
        Test.stopTest();
    }
    @isTest
    private static void testLoginSuccess() {
        system.debug(email);        
        User usr = [SELECT Id, Username, FederationIdentifier FROM User WHERE Email = :email];
        usr.FederationIdentifier = username;
        update usr;
        GoogleAuthHandler handler = new GoogleAuthHandler();
        Auth.UserData authUserData = new Auth.UserData('testId', 'testFirst', 'testLast',
            'testFirst testLast', username, null, username, 'en_US', 'google',
            null, new Map<String, String>{'language' => 'en_US'});
        Test.startTest();
        usr = handler.createUser(null, authUserData);
        Test.stopTest();    
    }
}