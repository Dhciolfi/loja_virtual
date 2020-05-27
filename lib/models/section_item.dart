class SectionItem {

  SectionItem.fromMap(Map<String, dynamic> map){
    image = map['image'] as String;
  }

  String image;

  @override
  String toString() {
    return 'SectionItem{image: $image}';
  }
}