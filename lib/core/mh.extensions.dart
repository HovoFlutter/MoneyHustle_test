extension SafeListAccess on List<int> {
  int tryIndex(int i) => (i >= 0 && i < length) ? this[i] : 0;
}
