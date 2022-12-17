import 'package:flutter/material.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/conf/ui/base_widgets.dart';
import 'package:nonoflex_alpha/view/document/document_list_viewmodel.dart';

import 'package:get/get.dart';

class DocumentListView extends BaseGetView<DocumentListViewModel> {
  @override
  Widget drawHeader() => drawMainPageTitle('DocumentListViewTitle'.tr);

}
