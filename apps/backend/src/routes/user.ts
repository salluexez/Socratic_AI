import { Router } from 'express';
import { getUserStats, updateUserSubjects, searchUsers, updateProfile } from '../controllers/userController';
import { authMiddleware } from '../middleware/auth';

const router = Router();

router.get('/stats', authMiddleware as any, getUserStats as any);
router.patch('/subjects', authMiddleware as any, updateUserSubjects as any);
router.get('/search', authMiddleware as any, searchUsers as any);
router.put('/profile', authMiddleware as any, updateProfile as any);

export default router;
