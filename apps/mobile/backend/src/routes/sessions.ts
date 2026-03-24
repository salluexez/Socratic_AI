import { Router } from 'express';
import { createSession, getSessions, getSessionById, endSession, deleteSession, renameSession } from '../controllers/sessionController';
import { authMiddleware } from '../middleware/auth';

const router = Router();

router.use(authMiddleware);

router.post('/', createSession);
router.get('/', getSessions);
router.get('/:id', getSessionById);
router.patch('/:id/end', endSession);
router.patch('/:id/rename', renameSession);
router.delete('/:id', deleteSession);

export default router;
