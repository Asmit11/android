import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/category_model.dart';
import '../models/user_model.dart';
import '../services/firebase_service.dart';

class CategoryRepository{
  CollectionReference<CategoryModel> categoryRef = FirebaseService.db.collection("categories")
      .withConverter<CategoryModel>(
    fromFirestore: (snapshot, _) {
      return CategoryModel.fromFirebaseSnapshot(snapshot);
    },
    toFirestore: (model, _) => model.toJson(),
  );
    Future<List<QueryDocumentSnapshot<CategoryModel>>> getCategories() async {
    try {
      var data = await categoryRef.get();
      bool hasData = data.docs.isNotEmpty;
      if(!hasData){
        makeCategory().forEach((element) async {
          await categoryRef.add(element);
        });
      }
      final response = await categoryRef.get();
      var category = response.docs;
      return category;
    } catch (err) {
      print(err);
      rethrow;
    }
  }

  Future<DocumentSnapshot<CategoryModel>>  getCategory(String categoryId) async {
      try{
        print(categoryId);
        final response = await categoryRef.doc(categoryId).get();
        return response;
      }catch(e){
        rethrow;
      }
  }

  List<CategoryModel> makeCategory(){
      return [
        CategoryModel(categoryName: "Piano", status: "active", imageUrl: "https://pearlriverusa.com/wp-content/uploads/elementor/thumbs/EU118S-PEARL-RIVER-oz7ccz3eghjimoiz1e7guy9urzw2a1d1repkpnfwjc.jpg"),
        CategoryModel(categoryName: "Electric Guitar", status: "active", imageUrl: "https://images.pexels.com/photos/165971/pexels-photo-165971.jpeg?cs=srgb&dl=pexels-m%C3%A9line-waxx-165971.jpg&fm=jpg"),
        CategoryModel(categoryName: "Drums", status: "active", imageUrl: "https://www.tama.com/usa/news_file/file/news_CK82S_VWS.jpg"),
        CategoryModel(categoryName: "Bass Guitar", status: "active", imageUrl: "https://images.ctfassets.net/r1mvpfown1y6/2S7dzpdBGa0Ggxr4fBoRNG/973cbbc9b83c613abe883b34bec8ff54/BassGuitarGuide_ArticlePageDetail_2624x800.jpg"),
        CategoryModel(categoryName: "Acoustic Guitar", status: "active", imageUrl: "https://images.all-free-download.com/images/graphiclarge/acoustic_guitar_184807.jpg"),
      ];
  }



}