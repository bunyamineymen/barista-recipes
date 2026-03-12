export enum RecipeCategory {
  MILK = 'Milk Recipes',
  DAIRY_FREE = 'Dairy-Free Recipes',
  COLD = 'Cold Coffees',
  SPECIAL = 'Special Recipes',
  TEA = 'Tea-Based'
}

export enum Difficulty {
  EASY = 'Easy',
  MEDIUM = 'Medium',
  HARD = 'Hard'
}

export interface Ingredient {
  name: string;
  amount: string;
}

export interface RecipeStep {
  description: string;
  timerSeconds?: number;
  type: 'espresso' | 'milk' | 'water' | 'other';
}

export interface Recipe {
  id: string;
  name: string;
  category: RecipeCategory;
  difficulty: Difficulty;
  ingredients: Ingredient[];
  steps: RecipeStep[];
  totalTimeMinutes: number;
  icon?: Resource;
}

export interface BrewRecord {
  recipeId: string;
  recipeName: string;
  timestamp: number;
  durationSeconds: number;
}
