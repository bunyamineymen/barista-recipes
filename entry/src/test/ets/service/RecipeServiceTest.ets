import { RecipeService } from '../../../main/ets/service/RecipeService';
import { RecipeCategory } from '../../../main/ets/model/RecipeModel';

export function runTests(): void {
  const service = RecipeService.getInstance();
  const allRecipes = service.getAllRecipes();
  console.info(`Test: Total recipes = ${allRecipes.length}`);

  if (allRecipes.length < 15) {
    console.error('Test Failed: Not enough recipes');
  } else {
    console.info('Test Passed: Recipe count');
  }

  const categories = Object.values(RecipeCategory);
  categories.forEach(cat => {
    const catRecipes = service.getRecipesByCategory(cat as RecipeCategory);
    console.info(`Test: Category ${cat} has ${catRecipes.length} recipes`);
    if (catRecipes.length === 0) {
      console.warn(`Test Warning: Category ${cat} is empty`);
    }
  });

  const latte = service.getRecipeById('latte');
  if (latte && latte.steps.length === 7) {
    console.info('Test Passed: Latte step count');
  } else {
    console.error(`Test Failed: Latte step count is ${latte?.steps.length ?? 'N/A'}`);
  }
}
