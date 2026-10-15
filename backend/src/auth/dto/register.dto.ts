import { IsEmail, IsNotEmpty, IsOptional, IsString, MinLength } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class RegisterDto {
  @ApiProperty({ example: 'Ana García', description: 'Nombre completo del usuario' })
  @IsString()
  @IsNotEmpty({ message: 'El nombre completo es obligatorio' })
  fullName: string;

  @ApiProperty({ example: 'ana@chamba.pe', description: 'Correo electrónico único' })
  @IsEmail({}, { message: 'El formato de correo electrónico no es válido' })
  @IsNotEmpty({ message: 'El correo electrónico es obligatorio' })
  email: string;

  @ApiProperty({ example: 'Password123!', description: 'Contraseña segura (mínimo 6 caracteres)' })
  @IsString()
  @MinLength(6, { message: 'La contraseña debe tener al menos 6 caracteres' })
  password: string;

  @ApiPropertyOptional({ example: '+51 974 555 101', description: 'Teléfono de contacto' })
  @IsOptional()
  @IsString()
  phone?: string;

  @ApiPropertyOptional({ example: 'Santa Victoria, Chiclayo', description: 'Distrito o ubicación' })
  @IsOptional()
  @IsString()
  district?: string;

  @ApiPropertyOptional({ example: 'Av. Grau 450', description: 'Dirección de referencia' })
  @IsOptional()
  @IsString()
  address?: string;
}
