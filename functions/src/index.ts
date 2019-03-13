// to test locally use:
// npm run shell
// lobbyCreation({host:""})

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
  lobbyDocs.docs.forEach(async (doc) => {
    // null checking needed for documents that don't get have a time
    const created = doc.get('createdAt') == null ? doc.get('createdAt').toDate() : doc.createTime.toDate();
    const now = new Date();
    const diffInMs = now.valueOf() - created.valueOf()

    //delete documents that are older than 20 minutes
    if (Math.floor(diffInMs / msInMinute) > 20) {
      await doc.ref.delete();
    }
  })
}

// firestore functions
export const lobbyCreation = functions.firestore.document(`lobbies/{lobbyId}`).onCreate(async (snapshot, context) => {
  //TODO make sure fields are not fudged
  await snapshot.ref.set({
    ...snapshot.data(),
    "createdAt": admin.firestore.FieldValue.serverTimestamp(),
  })

  //TODO find all the old documents in the lobby and delete them
  await findAndDeleteLobbies()

  return

})