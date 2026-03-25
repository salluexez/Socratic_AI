import { Router } from 'express';
import { createSession, getSessions, getSessionById, endSession, deleteSession, renameSession, shareSession, getSharedToMe, getSharedByMe, removeCollaborator, unshareSession } from '../controllers/sessionController';
import { authMiddleware } from '../middleware/auth';

const router = Router();

router.use(authMiddleware);

router.post('/', createSession);
router.get('/', getSessions);

// Shared sessions routes (must be before :id to avoid conflict)
router.get('/shared/to-me', getSharedToMe);
router.get('/shared/by-me', getSharedByMe);

router.get('/:id', getSessionById);
router.patch('/rename/:id', renameSession); // Consistency fix if needed, but original was /:id/rename
router.post('/:id/share', shareSession);
router.delete('/:id/share', unshareSession);
router.delete('/:id/collaborators/:collaboratorId', removeCollaborator);
router.patch('/:id/end', endSession);
router.patch('/:id/rename', renameSession);
router.delete('/:id', deleteSession);

export default router;
