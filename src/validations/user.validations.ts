import { z } from 'zod';

const emailSchema = z
  .string({
    required_error: 'Email is required.',
  })
  .email('Please enter a valid email address.');

const passwordSchema = z
  .string({
    required_error: 'Password is required.',
  })
  .trim()
  .min(8, 'Password must be 8-30 characters long.')
  .max(30, 'Password must be 8-30 characters long.')
  .regex(/\d+?/, 'Must contain atleast 1 number.')
  .regex(/[a-z]+?/, 'Must contain atleast 1 lowercase letter.')
  .regex(/[A-Z]+?/, 'Must contain atleast 1 uppercase letter.')
  .regex(/[\^$*.[\]{}()?"!@#%&/\\,><':;|_~`=+\- ]+?/, 'Must contain atleast 1 special character.');

export const signInBodySchema = z.object({
  email: emailSchema,
});

export const signupBodySchema = z.object({
  firstName: z
    .string({
      required_error: 'First name is required.',
    })
    .min(2, '2-50 characters required.')
    .max(50, '2-50 characters required.'),
  lastName: z
    .string({
      required_error: 'Last name is required.',
    })
    .min(2, '2-50 characters required.')
    .max(50, '2-50 characters required.'),
  email: emailSchema,
  password: passwordSchema,
});

export const autoVerifySignupBodySchema = signupBodySchema.extend({
  token: z.string().min(50, 'Invalid verification link').max(400, 'Invalid verification link'),
});

export const forgotPassBodySchema = z.object({
  email: emailSchema,
});

export const resetPassBodySchema = z.object({
  password: passwordSchema,
});

export const verifyAuthLinkBodySchema = z.object({
  token: z.string().min(50, 'Invalid verification link').max(400, 'Invalid verification link'),
});
