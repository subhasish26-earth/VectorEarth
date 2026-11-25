const express = require('express');
const router = express.Router();
const { processPayment, getInvoiceByBookingId, settleCodPayment } = require('../controllers/paymentController');
const { authenticate } = require('../middleware/auth');

router.use(authenticate);

router.post('/process', processPayment);
router.post('/settle-cod', settleCodPayment);
router.get('/invoice/:bookingId', getInvoiceByBookingId);

module.exports = router;
