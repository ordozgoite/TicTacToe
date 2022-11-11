//
//  FirebaseReference.swift
//  TicTacToe
//
//  Created by Victor Ordozgoite on 08/11/22.
//

import Firebase

enum FCollectionReference: String {
    case Game
}

func FirebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference {
    return Firestore.firestore().collection(collectionReference.rawValue)
}
