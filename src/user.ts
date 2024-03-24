import 'reflect-metadata';
import { ObjectType, Field, Int } from '@nestjs/graphql';
import { IsEmail } from 'class-validator';
import { Post } from './post';
import { Profile } from './profile';

@ObjectType()
export class User {
  @Field((type) => Int)
  id: number;

  @Field()
  @IsEmail()
  email: string;

  @Field((type) => String, { nullable: true })
  name?: string;

  @Field((type) => [Post], { nullable: true })
  posts?: [Post];

  @Field((type) => Profile, { nullable: true })
  profile?: Profile;
}
