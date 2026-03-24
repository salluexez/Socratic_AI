import { Router } from 'express';
import { registerToken, unregisterToken, updatePreferences } from '../controllers/notificationController';
import { authMiddleware } from '../middleware/auth';

const router = Router();

router.post('/register', authMiddleware, registerToken);
router.delete('/unregister', authMiddleware, unregisterToken);
router.patch('/preferences', authMiddleware, updatePreferences);

export default router;
