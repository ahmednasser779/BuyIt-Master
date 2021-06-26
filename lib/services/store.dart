import 'package:buyit/models/product.dart';
import 'package:buyit/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Store{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  addProduct(Product product){
    _firestore.collection(KProductCollection).add(
      {
        KProductName: product.pName,
        KProductPrice: product.pPrice,
        KProductDesc: product.pDescription,
        KProductCategory: product.pCategory,
        KProductLocation: product.pLocation
      }
    );
  }

  Stream<QuerySnapshot> loadProducts() {
    return _firestore.collection(KProductCollection).snapshots();
  }

  Stream<QuerySnapshot> loadOrders() {
    return _firestore.collection(KOrdersCollection).snapshots();
  }

  Stream<QuerySnapshot> loadOrderDetails(documentId) {
    return _firestore.collection(KOrdersCollection).doc(documentId).collection(KOrdersDetails).snapshots();
  }

  deleteProduct(String documentId){
    _firestore.collection(KProductCollection).doc(documentId).delete();
  }

  editProduct(Map<String, dynamic> data, String documentId){
    _firestore.collection(KProductCollection).doc(documentId).update(data);
  }

  storeOrders(Map<String, dynamic> data, List<Product> products){
    DocumentReference docRef = _firestore.collection(KOrdersCollection).doc();
    docRef.set(data);
    for(var product in products){
      docRef.collection(KOrdersDetails).add({
        KProductName: product.pName,
        KProductPrice: product.pPrice,
        KProductDesc: product.pDescription,
        KProductCategory: product.pCategory,
        KProductLocation: product.pLocation,
        KProductQuantity: product.pQuantity
      });
    }
  }

}