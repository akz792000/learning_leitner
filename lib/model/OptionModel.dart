class OptionModel {
  final dynamic image;
  final String title;
  final String subtitle;
  final Function? onTap;

  const OptionModel(
      {required this.image,
      required this.title,
      required this.subtitle,
      this.onTap});
}
