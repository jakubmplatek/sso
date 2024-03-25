global class GoogleAuthHandler implements Auth.RegistrationHandler{
    private User foundUser = null;  
    global boolean canCreateUser(Auth.UserData data) {
        List<User> lstUser = [SELECT Id, Username, FederationIdentifier, IsActive FROM User WHERE FederationIdentifier = :data.email];
        if (1 == lstUser.size()) {
            foundUser = lstUser[0];
            return true;
        }
        return false;
    }

    global User createUser(Id portalId, Auth.UserData data){
        if(!canCreateUser(data)) {
            //Returning null or throwing an exception fails the SSO flow
            return null;
        }
        // else - user found
        return foundUser;
    }

    global void updateUser(Id userId, Id portalId, Auth.UserData data){
    }
}