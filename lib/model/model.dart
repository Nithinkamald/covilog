class SliderModel {
  String svgAsset;
  String heading;
  String body;

  SliderModel({this.svgAsset, this.heading, this.body});

  void setsvgAsset(String getsvgAsset) {
    svgAsset = getsvgAsset;
  }

  void setHeading(String getHeading) {
    heading = getHeading;
  }

  void setBody(String getBody) {
    body = getBody;
  }

  String getsvgAsset() {
    return svgAsset;
  }

  String getHeading() {
    return heading;
  }

  String getBody() {
    return body;
  }
}

List<SliderModel> getSlides() {
  // ignore: deprecated_member_use
  List<SliderModel> slides = new List<SliderModel>();
  SliderModel sliderModel = new SliderModel();

  sliderModel.setsvgAsset('assets/icon1.svg');
  sliderModel
      .setHeading('Track shop visits with CoviLog');
  sliderModel.setBody(
      'A customer can scan QR code from the shop and track the visited shops.');
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  sliderModel.setsvgAsset('assets/wash.svg');
  sliderModel.setHeading('Wash Your Hands');
  sliderModel.setBody(
      'Clean your hands frequently using soap and water or a sanitizer');
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  sliderModel.setsvgAsset('assets/distance.svg');
  sliderModel.setHeading('Wear a mask');
  sliderModel.setBody(
      'Wear a mask and maintain social distancing. Don’t touch your eyes, nose or mouth.');
  slides.add(sliderModel);

  return slides;
}
