import 'PostTransactionModel.dart';

class PostTransactionModelDummy {
  List<PostTransactionModel>? postTransactionModelList;

  PostTransactionModelDummy({
    this.postTransactionModelList
  });

  PostTransactionModelDummy copy({
    List<PostTransactionModel>? postTransactionModelList
  }) {
    return PostTransactionModelDummy(
      postTransactionModelList: postTransactionModelList ?? this.postTransactionModelList
    );
  }
}