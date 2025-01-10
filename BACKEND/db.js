require('dotenv').config();
import { Pool } from 'pg';

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
  client.query('SET search_path TO ucabair', (err) => {
    if (err) {
      release();
      // eslint-disable-next-line no-console
      return console.error('Error setting search path', err.stack);
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
});

export default pool;
