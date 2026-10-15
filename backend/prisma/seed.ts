import { PrismaClient, AccountStatus } from '@prisma/client';
import * as bcrypt from 'bcrypt';

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Iniciando seed de datos para CHAMBA...');

  // Limpiar datos existentes en orden seguro si los hubiera
  await prisma.workerProfile.deleteMany({});
  await prisma.user.deleteMany({});

  const defaultPassword = 'Password123!';
  const passwordHash = await bcrypt.hash(defaultPassword, 10);

  // 1. Usuario Ana García (Cliente y Trabajadora - Electricista)
  const ana = await prisma.user.create({
    data: {
      fullName: 'Ana García',
      email: 'ana@chamba.pe',
      passwordHash,
      phone: '+51 974 555 101',
      district: 'Santa Victoria, Chiclayo',
      address: 'Av. Grau 450',
      status: AccountStatus.ACTIVE,
      workerProfile: {
        create: {
          bio: 'Técnica electricista profesional con más de 7 años de experiencia en instalaciones domiciliarias e industriales.',
          district: 'Santa Victoria, Chiclayo',
          specialty: 'Electricidad',
          isAvailable: true,
          rating: 4.9,
          completedJobs: 28,
        },
      },
    },
    include: { workerProfile: true },
  });

  // 2. Usuario José Torres (Cliente activo)
  const jose = await prisma.user.create({
    data: {
      fullName: 'José Torres',
      email: 'jose@chamba.pe',
      passwordHash,
      phone: '+51 974 555 202',
      district: 'La Victoria, Chiclayo',
      address: 'Calle Los Andes 120',
      status: AccountStatus.ACTIVE,
    },
  });

  // 3. Usuario Carlos Ramírez (Cliente y Trabajador - Gasfitería)
  const carlos = await prisma.user.create({
    data: {
      fullName: 'Carlos Ramírez',
      email: 'carlos@chamba.pe',
      passwordHash,
      phone: '+51 974 555 303',
      district: 'Pimentel, Chiclayo',
      address: 'Malecón Grau 310',
      status: AccountStatus.ACTIVE,
      workerProfile: {
        create: {
          bio: 'Gasfitero matriculado experto en bombas de agua, filtraciones y reparaciones de urgencia.',
          district: 'Pimentel, Chiclayo',
          specialty: 'Gasfitería',
          isAvailable: true,
          rating: 4.8,
          completedJobs: 42,
        },
      },
    },
    include: { workerProfile: true },
  });

  console.log('✅ Seed completado con éxito:');
  console.log(` - Ana García (${ana.email}) con perfil de trabajadora: ${ana.workerProfile?.specialty}`);
  console.log(` - José Torres (${jose.email}) rol cliente`);
  console.log(` - Carlos Ramírez (${carlos.email}) con perfil de trabajador: ${carlos.workerProfile?.specialty}`);
  console.log('🔑 Contraseña de prueba para todos: Password123!');
}

main()
  .catch((e) => {
    console.error('❌ Error durante el seed:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
