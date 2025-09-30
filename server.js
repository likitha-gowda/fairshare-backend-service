import express from 'express';
import dotenv from 'dotenv';
import errorHandler from './middleware/errorHandler.js';
import userRoutes from './routes/users.js';

dotenv.config();
const app = express();
const PORT = process.env.PORT || 5000;

//app.use(cors());
app.use(express.json());

app.use(express.json())
// app.use('/api/contacts', routes);
app.use('/api/users', userRoutes);
app.use(errorHandler);

app.get('/', (req, res) => {
  res.send('FairShare Backend is running');
});

app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
