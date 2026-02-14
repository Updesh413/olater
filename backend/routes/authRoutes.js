const express = require('express');
const { firebaseSync } = require('../controllers/authController');
const router = express.Router();

router.post('/firebase-sync', firebaseSync);

module.exports = router;
