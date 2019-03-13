// docs: https://firebase.google.com/docs/functions/firestore-events
import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin'
admin.initializeApp() // only needs to be done once (within any file)
const firestore = admin.firestore();
const settings = {/* your settings... */ timestampsInSnapshots: true };
firestore.settings(settings);


export const lobbyCreation = functions.firestore.document(`lobbies/{lobbyId}`).onCreate(async (snapshot, context) => {
  //TODO make sure fields are not fudged
  // const { path, uid, type } = snapshot.data()

  //TODO find all the old documents in the lobby and delete them

  return snapshot.ref.set({
    ...snapshot.data(),
    "createdAt": admin.firestore.FieldValue.serverTimestamp(),
  })
})