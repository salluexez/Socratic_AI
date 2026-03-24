import { Router } from 'express';
import { sendMessage } from '../controllers/chatController';
import { authMiddleware } from '../middleware/auth';

const router = Router();

router.post('/', authMiddleware, sendMessage);

export default router;
