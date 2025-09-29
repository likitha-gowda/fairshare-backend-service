import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
//import userRoutes from './routes/users.js';

dotenv.config();
const app = express();
const PORT = process.env.PORT || 5000;

app.use(cors());
app.use(express.json());

// Routes
//app.use('/api/users', userRoutes);
//app.use('/api/groups', groupRoutes);

app.get('/', (req, res) => {
  res.send('FairShare Backend is running');
});

app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
