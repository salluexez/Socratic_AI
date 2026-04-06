import { Router } from 'express';
import { createSession, getSessions, getSessionById, endSession, getSharedByMe, getSharedToMe } from '../controllers/sessionController';
import { authMiddleware } from '../middleware/auth';

const router = Router();

router.use(authMiddleware);

router.post('/', createSession);
router.get('/', getSessions);
router.get('/shared/by-me', getSharedByMe);
router.get('/shared/to-me', getSharedToMe);
router.get('/:id', getSessionById);
router.patch('/:id/end', endSession);

export default router;
