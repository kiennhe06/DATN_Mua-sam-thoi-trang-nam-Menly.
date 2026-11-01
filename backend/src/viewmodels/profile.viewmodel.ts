import { ProfileModel, type UserProfile, type ProfileUpdateDTO } from '../models/profile.model.js';

// Lop xu ly nghiep vu cho: Ho so ca nhan
export class ProfileViewModel {
  private model = new ProfileModel();

  async getProfile(userId: string): Promise<UserProfile> {
    return this.model.getProfile(userId);
  }

  async updateProfile(userId: string, input: ProfileUpdateDTO): Promise<UserProfile> {
    return this.model.updateProfile(userId, input);
  }

  async uploadAvatar(userId: string, file: Express.Multer.File): Promise<{ avatarUrl: string; filePath: string }> {
    return this.model.uploadAvatar(userId, file);
  }
}
