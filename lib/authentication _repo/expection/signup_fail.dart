class SignUpwithEmailAndPasswordFailure{
  final String message;

  const SignUpwithEmailAndPasswordFailure([this.message = 'An Unknown error occurred']);

  factory SignUpwithEmailAndPasswordFailure.code(String code){
    switch(code){
      case 'weak password':
        return const SignUpwithEmailAndPasswordFailure('Please enter The strong password ');
      case 'invalid-email':
        return const SignUpwithEmailAndPasswordFailure('Email is not valid');
      case 'email-already-in-use':
        return const SignUpwithEmailAndPasswordFailure('An Account already exits for that email');
      case 'operation-not-allowed':
        return const SignUpwithEmailAndPasswordFailure('Operation is not allowed');
      case 'user-disabled':
        return const SignUpwithEmailAndPasswordFailure('This User has been disabled ');
        default:
          return const SignUpwithEmailAndPasswordFailure();
    }
  }
}