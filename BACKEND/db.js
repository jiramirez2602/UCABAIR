require('dotenv').config();
const { Pool } = require('pg');

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: {
    rejectUnauthorized: false
  }
});

pool.connect((err, client, release) => {
  if (err) {
    // eslint-disable-next-line no-console
    return console.error('Error acquiring client', err.stack);
  }
  client.query('SELECT NOW()', (err, result) => {
    release();
    if (err) {
    // eslint-disable-next-line no-console
      return console.error('Error executing query', err.stack);
    }
    // eslint-disable-next-line no-console
    console.log(result.rows);
  });
});

module.exports = pool;
