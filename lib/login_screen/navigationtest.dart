// import 'package:transformer_page_view/transformer_page_view.dart';

// class ScaleAndFadeTransformer extends PageTransformer {
//   final double _scale;
//   final double _fade;

//   ScaleAndFadeTransformer({double fade: 0.3, double scale: 0.8})
//       : _fade = fade,
//         _scale = scale;

//   @override
//   Widget transform(Widget item, TransformInfo info) {
//     double position = info.position;
//     double scaleFactor = (1 - position.abs()) * (1 - _scale);
//     double fadeFactor = (1 - position.abs()) * (1 - _fade);
//     double opacity = _fade + fadeFactor;
//     double scale = _scale + scaleFactor;
//     return new Opacity(
//       opacity: opacity,
//       child: new Transform.scale(
//         scale: scale,
//         child: item,
//       ),
//     );
//   }
// }
