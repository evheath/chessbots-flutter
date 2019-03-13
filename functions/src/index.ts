// npm run shell
// lobbyCreation({host:""})

// docs: https://firebase.google.com/docs/functions/firestore-events
import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin'
admin.initializeApp() // only needs to be done once (within any file)
const firestore = admin.firestore();
const settings = {/* your settings... */ timestampsInSnapshots: true };
firestore.settings(settings);

// helpers
const msInMinute = 60000
const findAndDeleteLobbies = async () => {
  const lobbyDocs = await firestore.collection('lobbies').get()
  lobbyDocs.docs.forEach((doc) => {
    const created = doc.get('createdAt').toDate();
    const now = new Date();
    const diffInMs = now.valueOf() - created.valueOf()

    if (Math.floor(diffInMs / msInMinute) > 20) {
      doc.ref.delete().then().catch((e) => console.log)
    }
  })
}
// firestore functions
export const lobbyCreation = functions.firestore.document(`lobbies/{lobbyId}`).onCreate(async (snapshot, context) => {
  //TODO make sure fields are not fudged
  // const { path, uid, type } = snapshot.data()

  //TODO find all the old documents in the lobby and delete them
  findAndDeleteLobbies().then().catch((e) => console.log)

  return snapshot.ref.set({
    ...snapshot.data(),
    "createdAt": admin.firestore.FieldValue.serverTimestamp(),
  })
})