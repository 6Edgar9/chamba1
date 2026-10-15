import { IsOptional, IsString } from 'class-validator';
import { ApiPropertyOptional } from '@nestjs/swagger';

export class UpdateUserDto {
  @ApiPropertyOptional({ example: 'Ana García Pérez', description: 'Nombre completo actualizado' })
  @IsOptional()
  @IsString()
  fullName?: string;

  @ApiPropertyOptional({ example: '+51 974 999 888', description: 'Teléfono de contacto' })
  @IsOptional()
  @IsString()
  phone?: string;

  @ApiPropertyOptional({ example: 'José Leonardo Ortiz, Chiclayo', description: 'Distrito' })
  @IsOptional()
  @IsString()
  district?: string;

  @ApiPropertyOptional({ example: 'Av. Balta 1200', description: 'Dirección' })
  @IsOptional()
  @IsString()
  address?: string;
}
