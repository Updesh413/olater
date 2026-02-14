const admin = require('firebase-admin');
const User = require('../models/User');

// Initialize Firebase Admin (You will need to provide serviceAccountKey.json)
if (!admin.apps.length) {
  try {
    const serviceAccount = require('../serviceAccountKey.json');
    admin.initializeApp({
      credential: admin.credential.cert(serviceAccount)
    });
  } catch (e) {
    console.warn('Firebase Admin could not be initialized. serviceAccountKey.json might be missing.');
  }
}

const firebaseSync = async (req, res) => {
  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({ message: 'Unauthorized' });
  }

  const idToken = authHeader.split('Bearer ')[1];

  try {
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    const { uid, email, name, picture } = decodedToken;

    let user = await User.findOne({ firebaseId: uid });

    if (!user) {
      user = new User({
        firebaseId: uid,
        email: email,
        name: name || '',
        photoUrl: picture || ''
      });
      await user.save();
    }

    res.status(200).json({ message: 'User synced successfully', user });
  } catch (error) {
    console.error('Error verifying Firebase token:', error);
    res.status(401).json({ message: 'Invalid token' });
  }
};

module.exports = { firebaseSync };
