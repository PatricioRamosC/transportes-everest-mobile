enum ResponseType { json, html, text, image, multipart, unknown }

class HttpResponseData {
  ResponseType responseType; // Tipo de respuesta
  String? jsonResponse; // Para JSON
  String? htmlResponse; // Para HTML o texto
  List<int>? imageBytes; // Para imágenes o archivos binarios
  Map<String, dynamic>? multipartData; // Para multipart
  int? statusCode; // Código de estado HTTP

  // Constructor para inicializar los datos de la respuesta
  HttpResponseData({
    required this.responseType,
    this.jsonResponse,
    this.htmlResponse,
    this.imageBytes,
    this.multipartData,
    this.statusCode,
  });

  // Métodos para establecer los datos dependiendo del tipo de respuesta
  void setJsonResponse(String json) {
    responseType = ResponseType.json;
    jsonResponse = json;
  }

  void setHtmlResponse(String html) {
    responseType = ResponseType.html;
    htmlResponse = html;
  }

  void setTextResponse(String text) {
    responseType = ResponseType.text;
    htmlResponse = text;
  }

  void setImageResponse(List<int> image) {
    responseType = ResponseType.image;
    imageBytes = image;
  }

  void setMultipartResponse(Map<String, dynamic> multipart) {
    responseType = ResponseType.multipart;
    multipartData = multipart;
  }

  void setUnknownResponse() {
    responseType = ResponseType.unknown;
  }
}
