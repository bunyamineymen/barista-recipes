import { Recipe, RecipeCategory, Difficulty, BrewRecord } from '../model/RecipeModel';
import { preferences } from '@kit.ArkData';
import { common } from '@kit.AbilityKit';
import { CoffeeConstants } from '../common/Constants';

export class RecipeService {
  private static instance: RecipeService;
  private pref: preferences.Preferences | null = null;
  private context: common.Context | null = null;

  private recipes: Recipe[] = [
    // MILK RECIPES
    {
      id: 'latte',
      name: 'Latte',
      category: RecipeCategory.MILK,
      difficulty: Difficulty.MEDIUM,
      totalTimeMinutes: 5,
      icon: $r('app.media.ic_latte'),
      ingredients: [{ name: 'Espresso', amount: '30ml' }, { name: 'Milk', amount: '200ml' }],
      steps: [
        { description: 'Grind coffee beans', timerSeconds: 15, type: 'espresso' },
        { description: 'Pull espresso shot', timerSeconds: 25, type: 'espresso' },
        { description: 'Heat milk to 65C', timerSeconds: 30, type: 'milk' },
        { description: 'Create microfoam', timerSeconds: 20, type: 'milk' },
        { description: 'Fill the cup', type: 'milk' },
        { description: 'Add latte art', type: 'other' },
        { description: 'Ready to serve', type: 'other' }
      ]
    },
    {
      id: 'cappuccino',
      name: 'Cappuccino',
      category: RecipeCategory.MILK,
      difficulty: Difficulty.MEDIUM,
      totalTimeMinutes: 5,
      icon: $r('app.media.ic_cappuccino'),
      ingredients: [{ name: 'Espresso', amount: '30ml' }, { name: 'Milk', amount: '150ml' }],
      steps: [
        { description: 'Pull espresso shot', timerSeconds: 25, type: 'espresso' },
        { description: 'Froth milk for dry foam', timerSeconds: 40, type: 'milk' },
        { description: 'Wait for layers', timerSeconds: 10, type: 'other' },
        { description: 'Add dry foam', type: 'milk' },
        { description: 'Layer the drink', type: 'milk' },
        { description: 'Ready to serve', type: 'other' }
      ]
    },
    {
      id: 'flat_white',
      name: 'Flat White',
      category: RecipeCategory.MILK,
      difficulty: Difficulty.MEDIUM,
      totalTimeMinutes: 4,
      icon: $r('app.media.ic_latte'),
      ingredients: [{ name: 'Double Espresso', amount: '60ml' }, { name: 'Milk', amount: '120ml' }],
      steps: [
        { description: 'Pull double espresso', timerSeconds: 30, type: 'espresso' },
        { description: 'Steam milk (thin foam)', timerSeconds: 25, type: 'milk' },
        { description: 'Microfoam check', type: 'milk' },
        { description: 'Pour milk into espresso', type: 'milk' },
        { description: 'Ready to serve', type: 'other' }
      ]
    },
    // DAIRY-FREE RECIPES
    {
      id: 'americano',
      name: 'Americano',
      category: RecipeCategory.DAIRY_FREE,
      difficulty: Difficulty.EASY,
      totalTimeMinutes: 3,
      icon: $r('app.media.ic_americano'),
      ingredients: [{ name: 'Espresso', amount: '60ml' }, { name: 'Hot Water', amount: '120ml' }],
      steps: [
        { description: 'Pull double espresso shot', timerSeconds: 30, type: 'espresso' },
        { description: 'Heat water to 90C', timerSeconds: 60, type: 'water' },
        { description: 'Add hot water', type: 'water' },
        { description: 'Ready to serve', type: 'other' }
      ]
    },
    {
      id: 'aerocano',
      name: 'Aerocano',
      category: RecipeCategory.DAIRY_FREE,
      difficulty: Difficulty.MEDIUM,
      totalTimeMinutes: 4,
      icon: $r('app.media.ic_espresso'),
      ingredients: [{ name: 'Espresso', amount: '60ml' }, { name: 'Ice', amount: '100g' }, { name: 'Water', amount: '50ml' }],
      steps: [
        { description: 'Pull double espresso', timerSeconds: 30, type: 'espresso' },
        { description: 'Add ice and water to pitcher', type: 'other' },
        { description: 'Steam espresso and ice together', timerSeconds: 20, type: 'milk' },
        { description: 'Texture check', type: 'other' },
        { description: 'Pour into glass', type: 'other' }
      ]
    },
    {
      id: 'espresso',
      name: 'Espresso',
      category: RecipeCategory.DAIRY_FREE,
      difficulty: Difficulty.MEDIUM,
      totalTimeMinutes: 2,
      icon: $r('app.media.ic_espresso'),
      ingredients: [{ name: 'Coffee beans', amount: '18g' }],
      steps: [
        { description: 'Grind coffee', type: 'espresso' },
        { description: 'Tamp coffee', type: 'espresso' },
        { description: 'Pull shot', timerSeconds: 25, type: 'espresso' }
      ]
    },
    // COLD COFFEES
    {
      id: 'iced_latte',
      name: 'Iced Latte',
      category: RecipeCategory.COLD,
      difficulty: Difficulty.EASY,
      totalTimeMinutes: 3,
      icon: $r('app.media.ic_iced_coffee'),
      ingredients: [{ name: 'Espresso', amount: '60ml' }, { name: 'Cold Milk', amount: '150ml' }, { name: 'Ice', amount: 'Full glass' }],
      steps: [
        { description: 'Pull double espresso', timerSeconds: 30, type: 'espresso' },
        { description: 'Fill glass with ice', type: 'other' },
        { description: 'Add cold milk', type: 'milk' },
        { description: 'Pour espresso over milk', type: 'espresso' }
      ]
    },
    {
      id: 'cold_brew',
      name: 'Cold Brew',
      category: RecipeCategory.COLD,
      difficulty: Difficulty.EASY,
      totalTimeMinutes: 2,
      icon: $r('app.media.ic_iced_coffee'),
      ingredients: [{ name: 'Cold Brew Conc.', amount: '100ml' }, { name: 'Water/Milk', amount: '100ml' }, { name: 'Ice', amount: 'Some' }],
      steps: [
        { description: 'Add ice to glass', type: 'other' },
        { description: 'Pour Cold Brew concentrate', type: 'espresso' },
        { description: 'Add water or milk', type: 'water' }
      ]
    },
    {
      id: 'iced_americano',
      name: 'Iced Americano',
      category: RecipeCategory.COLD,
      difficulty: Difficulty.EASY,
      totalTimeMinutes: 2,
      icon: $r('app.media.ic_iced_coffee'),
      ingredients: [{ name: 'Espresso', amount: '60ml' }, { name: 'Cold Water', amount: '100ml' }, { name: 'Ice', amount: 'Some' }],
      steps: [
        { description: 'Add ice to glass', type: 'other' },
        { description: 'Add cold water', type: 'water' },
        { description: 'Pour espresso over water', type: 'espresso' }
      ]
    },
    {
      id: 'frappe',
      name: 'Frappe',
      category: RecipeCategory.COLD,
      difficulty: Difficulty.MEDIUM,
      totalTimeMinutes: 5,
      icon: $r('app.media.ic_iced_coffee'),
      ingredients: [{ name: 'Instant Coffee', amount: '2 tsp' }, { name: 'Sugar', amount: '2 tsp' }, { name: 'Water', amount: '30ml' }, { name: 'Ice/Milk', amount: 'Some' }],
      steps: [
        { description: 'Mix coffee, sugar, water', type: 'other' },
        { description: 'Whisk until frothy', timerSeconds: 60, type: 'other' },
        { description: 'Add ice and milk', type: 'milk' }
      ]
    },
    // SPECIAL RECIPES
    {
      id: 'mocha',
      name: 'Mocha',
      category: RecipeCategory.SPECIAL,
      difficulty: Difficulty.MEDIUM,
      totalTimeMinutes: 6,
      icon: $r('app.media.ic_latte'),
      ingredients: [{ name: 'Espresso', amount: '30ml' }, { name: 'Choc. Syrup', amount: '20ml' }, { name: 'Milk', amount: '150ml' }],
      steps: [
        { description: 'Mix espresso and syrup', type: 'espresso' },
        { description: 'Steam milk', timerSeconds: 35, type: 'milk' },
        { description: 'Pour milk over mixture', type: 'milk' }
      ]
    },
    {
      id: 'caramel_macchiato',
      name: 'Caramel Macchiato',
      category: RecipeCategory.SPECIAL,
      difficulty: Difficulty.MEDIUM,
      totalTimeMinutes: 5,
      icon: $r('app.media.ic_latte'),
      ingredients: [{ name: 'Espresso', amount: '30ml' }, { name: 'Vanilla Syrup', amount: '15ml' }, { name: 'Milk', amount: '150ml' }, { name: 'Caramel', amount: 'Drizzle' }],
      steps: [
        { description: 'Add vanilla syrup to glass', type: 'other' },
        { description: 'Steam milk', timerSeconds: 30, type: 'milk' },
        { description: 'Pour milk into glass', type: 'milk' },
        { description: 'Pour espresso through milk', type: 'espresso' },
        { description: 'Add caramel drizzle', type: 'other' }
      ]
    },
    {
      id: 'affogato',
      name: 'Affogato',
      category: RecipeCategory.SPECIAL,
      difficulty: Difficulty.EASY,
      totalTimeMinutes: 3,
      icon: $r('app.media.ic_espresso'),
      ingredients: [{ name: 'Vanilla Ice Cream', amount: '1 scoop' }, { name: 'Espresso', amount: '30ml' }],
      steps: [
        { description: 'Place ice cream in cup', type: 'other' },
        { description: 'Pull espresso shot', timerSeconds: 25, type: 'espresso' },
        { description: 'Pour espresso over ice cream', type: 'espresso' }
      ]
    },
    // TEA BASED
    {
      id: 'matcha_latte',
      name: 'Matcha Latte',
      category: RecipeCategory.TEA,
      difficulty: Difficulty.MEDIUM,
      totalTimeMinutes: 5,
      icon: $r('app.media.ic_tea'),
      ingredients: [{ name: 'Matcha Powder', amount: '2g' }, { name: 'Hot Water', amount: '30ml' }, { name: 'Milk', amount: '200ml' }],
      steps: [
        { description: 'Whisk matcha and hot water', timerSeconds: 60, type: 'other' },
        { description: 'Steam milk', timerSeconds: 30, type: 'milk' },
        { description: 'Pour milk over matcha', type: 'milk' }
      ]
    },
    {
      id: 'chai_latte',
      name: 'Chai Latte',
      category: RecipeCategory.TEA,
      difficulty: Difficulty.EASY,
      totalTimeMinutes: 4,
      icon: $r('app.media.ic_tea'),
      ingredients: [{ name: 'Chai Concentrate', amount: '50ml' }, { name: 'Milk', amount: '200ml' }, { name: 'Cinnamon', amount: 'Pinch' }],
      steps: [
        { description: 'Pour Chai concentrate', type: 'other' },
        { description: 'Steam milk', timerSeconds: 30, type: 'milk' },
        { description: 'Pour milk over Chai', type: 'milk' },
        { description: 'Top with cinnamon', type: 'other' }
      ]
    }
  ];

  private constructor() {}

  static getInstance(): RecipeService {
    if (!RecipeService.instance) {
      RecipeService.instance = new RecipeService();
    }
    return RecipeService.instance;
  }

  async init(context: common.Context): Promise<void> {
    this.context = context;
    this.pref = await preferences.getPreferences(context, CoffeeConstants.PREFERENCES_NAME);
  }

  getAllRecipes(): Recipe[] {
    return this.recipes;
  }

  getRecipesByCategory(category: RecipeCategory): Recipe[] {
    return this.recipes.filter(r => r.category === category);
  }

  getRecipeById(id: string): Recipe | undefined {
    return this.recipes.find(r => r.id === id);
  }

  async toggleFavorite(recipeId: string): Promise<void> {
    if (!this.pref) return;
    try {
      let favorites = await this.getFavorites();
      const index = favorites.indexOf(recipeId);
      if (index > -1) {
        favorites.splice(index, 1);
      } else {
        favorites.push(recipeId);
      }
      await this.pref.put(CoffeeConstants.KEY_FAVORITES, JSON.stringify(favorites));
      await this.pref.flush();
    } catch (err) {
      console.error('Failed to toggle favorite', err);
    }
  }

  async isFavorite(recipeId: string): Promise<boolean> {
    const favorites = await this.getFavorites();
    return favorites.includes(recipeId);
  }

  async getFavorites(): Promise<string[]> {
    if (!this.pref) return [];
    try {
      const favsJson = await this.pref.get(CoffeeConstants.KEY_FAVORITES, '[]');
      return JSON.parse(favsJson as string);
    } catch (err) {
      console.error('Failed to get favorites', err);
      return [];
    }
  }

  async addBrewHistory(record: BrewRecord): Promise<void> {
    if (!this.pref) return;
    try {
      let history = await this.getBrewHistory();
      history.unshift(record);
      if (history.length > 20) {
        history = history.slice(0, 20);
      }
      await this.pref.put(CoffeeConstants.KEY_HISTORY, JSON.stringify(history));
      await this.pref.flush();
    } catch (err) {
      console.error('Failed to add brew history', err);
    }
  }

  async getBrewHistory(): Promise<BrewRecord[]> {
    if (!this.pref) return [];
    try {
      const historyJson = await this.pref.get(CoffeeConstants.KEY_HISTORY, '[]');
      return JSON.parse(historyJson as string);
    } catch (err) {
      console.error('Failed to get history', err);
      return [];
    }
  }
}
