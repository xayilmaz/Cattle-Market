class Hatalar {
  static String goster(String hataKodu) {
    switch (hataKodu) {
      case 'email-already-in-use':
        return "This mail is already in use, please use a different mail.";

      case 'user-not-found':
        return "The user is not registered in the system. Please register first.";
      case 'wrong-password':
        return "Entered password is incorrect.";

      default:
        return "An error occurred please try again later.";
    }
  }
}
