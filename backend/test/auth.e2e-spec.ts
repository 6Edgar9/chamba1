import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import request from 'supertest';
import { AppModule } from '../src/app.module.js';

describe('CHAMBA Auth & User Flow (e2e)', () => {
  let app: INestApplication;
  const uniqueId = Date.now();
  const testUser = {
    fullName: 'Test Automation User',
    email: `test-${uniqueId}@chamba.pe`,
    password: 'Password123!',
    phone: '+51 988 777 666',
    district: 'Chiclayo Centro',
    address: 'Calle San José 500',
  };
  let userToken = '';

  beforeAll(async () => {
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = moduleFixture.createNestApplication();
    app.setGlobalPrefix('api/v1');
    app.useGlobalPipes(
      new ValidationPipe({
        whitelist: true,
        transform: true,
      }),
    );
    await app.init();
  });

  afterAll(async () => {
    await app.close();
  });

  describe('1. Registro de usuarios', () => {
    it('POST /api/v1/auth/register — debe registrar un usuario nuevo y devolver token', async () => {
      const response = await request(app.getHttpServer())
        .post('/api/v1/auth/register')
        .send(testUser)
        .expect(201);

      expect(response.body).toHaveProperty('accessToken');
      expect(response.body).toHaveProperty('user');
      expect(response.body.user.email).toBe(testUser.email);
      expect(response.body.user).not.toHaveProperty('passwordHash');
      userToken = response.body.accessToken;
    });

    it('POST /api/v1/auth/register — debe rechazar correo duplicado con 409', async () => {
      const response = await request(app.getHttpServer())
        .post('/api/v1/auth/register')
        .send(testUser)
        .expect(409);

      expect(response.body.message).toContain('ya se encuentra registrado');
    });

    it('POST /api/v1/auth/register — debe rechazar contraseña corta con 400', async () => {
      await request(app.getHttpServer())
        .post('/api/v1/auth/register')
        .send({
          fullName: 'Bad User',
          email: `bad-${uniqueId}@chamba.pe`,
          password: '123',
        })
        .expect(400);
    });
  });

  describe('2. Inicio de sesión', () => {
    it('POST /api/v1/auth/login — debe autenticar con credenciales correctas', async () => {
      const response = await request(app.getHttpServer())
        .post('/api/v1/auth/login')
        .send({
          email: testUser.email,
          password: testUser.password,
        })
        .expect(200);

      expect(response.body).toHaveProperty('accessToken');
      expect(response.body.user.email).toBe(testUser.email);
    });

    it('POST /api/v1/auth/login — debe rechazar credenciales incorrectas con 401', async () => {
      await request(app.getHttpServer())
        .post('/api/v1/auth/login')
        .send({
          email: testUser.email,
          password: 'WrongPassword!',
        })
        .expect(401);
    });
  });

  describe('3. Consulta y actualización de usuario autenticado', () => {
    it('GET /api/v1/users/me — debe rechazar peticiones sin token con 401', async () => {
      await request(app.getHttpServer())
        .get('/api/v1/users/me')
        .expect(401);
    });

    it('GET /api/v1/users/me — debe devolver información del usuario autenticado con Bearer token', async () => {
      const response = await request(app.getHttpServer())
        .get('/api/v1/users/me')
        .set('Authorization', `Bearer ${userToken}`)
        .expect(200);

      expect(response.body.email).toBe(testUser.email);
      expect(response.body.fullName).toBe(testUser.fullName);
      expect(response.body).not.toHaveProperty('passwordHash');
    });

    it('PATCH /api/v1/users/me — debe actualizar datos del usuario autenticado', async () => {
      const response = await request(app.getHttpServer())
        .patch('/api/v1/users/me')
        .set('Authorization', `Bearer ${userToken}`)
        .send({ district: 'Santa Victoria Actualizado' })
        .expect(200);

      expect(response.body.district).toBe('Santa Victoria Actualizado');
    });
  });

  describe('4. Perfil de trabajador', () => {
    it('PUT /api/v1/worker-profile/me — debe crear o actualizar perfil de trabajador', async () => {
      const response = await request(app.getHttpServer())
        .put('/api/v1/worker-profile/me')
        .set('Authorization', `Bearer ${userToken}`)
        .send({
          bio: 'Especialista en mantenimiento técnico',
          district: 'Chiclayo',
          specialty: 'Gasfitería',
          isAvailable: true,
        })
        .expect(200);

      expect(response.body.specialty).toBe('Gasfitería');
      expect(response.body.bio).toBe('Especialista en mantenimiento técnico');
    });

    it('GET /api/v1/worker-profile/me — debe consultar el perfil de trabajador creado', async () => {
      const response = await request(app.getHttpServer())
        .get('/api/v1/worker-profile/me')
        .set('Authorization', `Bearer ${userToken}`)
        .expect(200);

      expect(response.body.specialty).toBe('Gasfitería');
      expect(response.body.user.email).toBe(testUser.email);
    });
  });
});
