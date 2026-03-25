import { Router } from 'express';
import { startChat, sendMessage, getChats, getChatById, deleteChat, updateChatTopic, shareChat, getSharedChats, unshareChat, revokeAllShares } from '../controllers/chatController';
import { authMiddleware } from '../middleware/auth';

const router = Router();

router.use(authMiddleware);

router.post('/start', startChat);
router.post('/message', sendMessage);
router.get('/shared', getSharedChats);
router.get('/', getChats);
router.get('/:id', getChatById);
router.delete('/:id', deleteChat);
router.patch('/:id/topic', updateChatTopic);
router.post('/:id/share', shareChat);
router.delete('/:id/share', revokeAllShares);
router.delete('/:id/share/:targetUserId', unshareChat);

export default router;
