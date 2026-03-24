import { Router } from 'express';
import { createSession, getSessions, getSessionById, endSession, deleteSession } from '../controllers/sessionController';
import { authMiddleware } from '../middleware/auth';

const router = Router();

router.use(authMiddleware);

router.post('/', createSession);
router.get('/', getSessions);
router.get('/:id', getSessionById);
router.patch('/:id/end', endSession);
router.delete('/:id', deleteSession);

export default router;
