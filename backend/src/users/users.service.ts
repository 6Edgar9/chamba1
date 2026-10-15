import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service.js';
import { UpdateUserDto } from './dto/update-user.dto.js';

@Injectable()
export class UsersService {
  constructor(private prisma: PrismaService) {}

  async findMe(userId: string) {
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
      include: { workerProfile: true },
    });

    if (!user) {
      throw new NotFoundException('Usuario no encontrado');
    }

    const { passwordHash: _, ...safeUser } = user;
    return safeUser;
  }

  async updateMe(userId: string, updateDto: UpdateUserDto) {
    const user = await this.prisma.user.update({
      where: { id: userId },
      data: {
        ...(updateDto.fullName ? { fullName: updateDto.fullName.trim() } : {}),
        ...(updateDto.phone !== undefined ? { phone: updateDto.phone?.trim() } : {}),
        ...(updateDto.district !== undefined ? { district: updateDto.district?.trim() } : {}),
        ...(updateDto.address !== undefined ? { address: updateDto.address?.trim() } : {}),
      },
      include: { workerProfile: true },
    });

    const { passwordHash: _, ...safeUser } = user;
    return safeUser;
  }
}
