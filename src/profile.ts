import { Field } from '@nestjs/graphql';
import { ObjectType } from '@nestjs/graphql';
import { ID } from '@nestjs/graphql';
import { Int } from '@nestjs/graphql';
import { User } from './user';

@ObjectType()
export class Profile {
  @Field(() => ID, { nullable: false })
  id!: number;

  @Field(() => String, { nullable: true })
  bio?: string;

  @Field(() => Int, { nullable: false })
  userId!: number;

  @Field(() => User, { nullable: false })
  user: User;
}
