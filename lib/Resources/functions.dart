/// • Various functions of WE.
class Functions {
  /// • Checks the parameter and returns true if the parameter is null.
  ///
  /// • If parameter is not null, returns false.
  ///
  /// • In case of an error, returns false.
  bool nullCheck(var value) {
    if (value == null || value?.trim() == '') {
      return true;
    } else if (value != null || value?.trim() != '') {
      return false;
    } else {
      return false;
    }
  }
}
