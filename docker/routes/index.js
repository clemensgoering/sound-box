const express = require('express');
const router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { title: 'Soundbox' });
});

router.get('/overview', function(req, res, next) {
  res.render('overview', { title: 'Overview' });
});

router.get('/add', function(req, res, next) {
  res.render('add', { title: 'Add' });
});

router.get('/delete', function(req, res, next) {
  res.render('delete', { title: 'Delete' });
});

module.exports = router;
