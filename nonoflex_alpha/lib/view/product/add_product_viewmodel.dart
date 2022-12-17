import 'package:nonoflex_alpha/cmm/base.dart';

enum ViewMode {
  add,
  edit,
}

class AddProductViewModel extends BaseController {

  final ViewMode viewMode = ViewMode.add;
}